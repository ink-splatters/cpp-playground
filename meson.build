project('cpp-playground', 'cpp',
  version : '0.1',
  default_options : ['warning_level=3',
                     'werror=true',
                     'cpp_std=c++20',
                     'cpp_stdlib=libc++',
                     'optimization=3'])

exe = executable('cpp-playground', 'cpp_playground.cpp',
  install : true)

test('basic', exe)
