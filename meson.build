project('cpp-playground', 'cpp',
  version : '0.1',
  default_options : ['warning_level=3',
                     'werror=true',
                     'cpp_std=c++20',
                     'cpp_stdlib=libc++',
                     'optimization=3',
                     'b_pch=true'])


  sources = files(
    'main.cpp'
    )
  exe = executable('cpp-playground',
    sources: sources,
    cpp_pch: 'pch/pch.h',
    install : true)

  test('basic', exe)
