project('com.github.plugarut.pwned-checker', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

executable(
    meson.project_name(),
    'src/Services/PwnedAPI.vala',
    'src/Application.vala',
    'src/MainWindow.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        meson.get_compiler('c').find_library('m', required : false)
  ],
  install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
