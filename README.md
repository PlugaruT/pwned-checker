[![Build Status](https://travis-ci.org/PlugaruT/pwned-checker.svg?branch=master)](https://travis-ci.org/PlugaruT/pwned-checker)

<p align="center">
  <img src="https://raw.githubusercontent.com/PlugaruT/pwned-checker/master/data/icons/128/com.github.plugarut.pwned-checker.svg?new" alt="Icon" />
</p>
<h1 align="center">Pwned Checker</h1>
<p align="center">
  <a href="https://appcenter.elementary.io/com.github.plugarut.pwned-checker"><img src="https://appcenter.elementary.io/badge.svg?new" alt="Get it on AppCenter" /></a>
</p>

<p align="center"><img src="https://github.com/PlugaruT/pwned-checker/blob/master/data/screenshot_0.png" alt="Screenshot" />
</p>

Simple application for interacting with [haveibeenpwned](https://haveibeenpwned.com/) API.

## Building and Installation

You'll need the following dependencies:

```
libglib2.0-dev
libgranite-dev
libgtk-3-dev
meson
valac
```


Run `meson` to configure the build environment and then `ninja` to build

```
meson build --prefix=/usr
cd build
ninja
```

To install, use `ninja install`

```
sudo ninja install
```

## TODO
Things I plan to implement:
 - Searching password by range using SHA-1
