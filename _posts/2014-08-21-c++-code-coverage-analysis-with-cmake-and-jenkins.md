---
layout: post
title: "C++ Code Coverage Analysis with CMake and Jenkins"
date: 2014-08-21 19:30:00
updated: 2015-04-07 16:20:00
comments: true
published: true
categories:
  - Programming
  - English
---

Having a working test suite for your library or program is common knowledge.
Using a continuous integration workflow like [git-flow]() backed by [Travis CI]() or a [Jenkins]()
instance is already a success story and widely used.
To ease up the build process of a C++ library/program on different platforms, many projects decide
to use [CMake]().

So far, so good.
But how good is your test suite?
Does it cover all the functionality and code in your library?
Does it catch all the different branches and edge-cases?

This little article describes a way of using [lcov]() to generate a test coverage report for a
*CMake*-based C++ project.

<!-- more -->

Let us assume you have your C++ project set up with *CMake* as its build system.
As well, assume your code - including the test suite - compiles fine with [GCC]().
I probably don't have to mention, that you will always want to do out-of-source builds.

## Compiling with Profiling Flags

The first step to enable coverage reports is to compile your program with *GCC*'s flags `-gp`, 
`-ftest-coverage` and `-fprofile-arcs` as well as linking them with `-fprofile-arcs`.
For documentation on those flags, see [GCC's man page "3.9 Options for Debugging Your Program or GCC"](https://gcc.gnu.org/onlinedocs/gcc-4.8.3/gcc/Debugging-Options.html#Debugging-Options).

You can conditionally add those flags by defining a *CMake* option, e.g. `my_project_WITH_PROF`:

{% highlight cmake %}
option(my_project_WITH_PROF "Enable profiling and coverage report analysis" OFF)

#...

# assuming target "my_prog" exists
if(${CMAKE_COMPILER_ID} MATCHES GNU AND $my_project_WITH_PROF)
    set_target_properties(my_prog
        PROPERTIES COMPILE_FLAGS "${CMAKE_CXX_FLAGS} -gp -fprofile-coverage -fprofile-args
                   LINK_FLAGS "-fprofile-arcs")
endif()
{% endhighlight %}

That is all regarding compilation.
What is left is to run the compiled program, capture the coverage data and generate a HTML report out
of it.

## Capturing Profiling and Coverage Data

For these steps you will need [lcov](), which brings in two commands: `lcov` and `genhtml`.

The procedure is simple as follows (in the same path as the executable):

1. zero out preexisting coverage and profiling data

       lcov --zerocounters  --directory .

2. run the executable

       ./my_prog

3. capture the coverage and profiling data

       lcov --directory . --capture --output-file my_prog.info

4. generate the HTML report

       genhtml --output-directory coverage \
         --demangle-cpp --num-spaces 2 --sort \
         --title "My Program's Test Coverage" \
         --function-coverage --branch-coverage --legend \
         my_prog.info

## Automation with CMake and CTest

As stated in the beginning, we want coverage reports for our test suite, thus we will use [CTest]()
for a nice and somehow "standardized" interface to our test suite (and because *CMake* comes with it).
We have enabled *CTest* in our `CMakeLists.txt` (call to `enable_testing()`) and added our `my_prog`
target as a test:

    add_test(NAME my_prog)

Now we can simply run `make test` or `ctest` in our build directory and it will not only run all
configured test, but also generate all the profiling and coverage data we later can capture with
*lcov* (cf. step 3 above).

But how can we zero out preexisting counters before running the test suite and gather all the 
different test's data afterwards?

For this task, I have written a little shell script to do exactly that.
The script is meant to be run in the root folder of the project with the build directory as a child
of it.
As well, it assumes that the test suite is for a header-only library with the header files located
in `<PROJECT_ROOT>/include`.
To capture coverage of files in other directories you need to adjust the calls to `lcov --extract`
(line 40-41: adjust the glob pattern) and `genhtml` (line 50-60: adjust the `--prefix` argument).

For convenience, you might want to put your adjusted script in the root of your project and under
revision control.

{% highlight bash %}
#!/bin/sh
basepath=`pwd`

function print_help {
  echo "#######################################################################"
  echo "###               Generation of Test Coverage Report                ###"
  echo "#                                                                     #"
  echo "# First (and only) parameter must be the name of the build directory  #"
  echo "#                                                                     #"
  echo "# Example:                                                            #"
  echo "#   ./generate_coverage.sh build_gcc                                  #"
  echo "#                                                                     #"
  echo "#######################################################################"
  return 0
}

if [[ $# -ne 1 ]]
then
  print_help
  echo "ERROR: Please name the build directory as the first parameter."
  exit -1
fi

builddir=${1}
cd ${builddir}

rm -rf ${basepath}/coverage
mkdir -p ${basepath}/coverage

for testdir in `find ${basepath}/${builddir} -type d | grep -o 'tests/.*/.*\dir'`
do
  testname=`expr "$testdir" : '.*\(test_[a-zA-Z\-_]*\)\.dir'`
  echo "Gathering Coverage for ${testname}"
  cd $testdir
  lcov --zerocounters  --directory .
  cd ${basepath}/${builddir}
  ctest -R $testname
  cd $testdir
  lcov --directory . --capture --output-file ${testname}.info.tmp
  lcov --extract ${testname}.info.tmp "*${basepath}/include/**/*" \
    --output-file ${testname}.info
  rm ${testname}.info.tmp
  cd ${basepath}/${builddir}
  if [[ -e all_tests.info ]]
  then
    lcov --add-tracefile all_tests.info \
      --add-tracefile ${testdir}/${testname}.info \
      --output-file all_tests.info
  else
    lcov --add-tracefile ${testdir}/${testname}.info \
      --output-file all_tests.info
  fi
done

cd ${basepath}
genhtml --output-directory ./coverage \
  --demangle-cpp --num-spaces 2 --sort \
  --title "My Program Test Coverage" --prefix ${basepath}/include \
  --function-coverage --branch-coverage --legend \
  ${basepath}/${builddir}/all_tests.info
{% endhighlight %}

## Let Jenkins Publish the Report

For a real open source project a transparent integration process is vital, thus we want our *Jenkins*
instance to generate and publish the coverage reports for us.

In the - hopefully already existing - job where we run the test suite, simply add a step to execute
the above script.
Finally, on success, publish the result by adding a *Publish HTML reports* post-build action with
`coverage` as the HTML directory to archive, `index.html` as the index page and a good but short
name, e.g. `Test Coverage`.
After the first build, you will be able to browse the final HTML report at 
`<your-jenkins-domain>/job/<MY_PROJECT_TESTS>/Test_Coverage`.
