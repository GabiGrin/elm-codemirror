# elm-codemirror

Elm bindings for [CodeMirror](https://codemirror.net/)

Uses virtual-dom hooks as proposed by @sgillis ([blog post](http://sgillis.github.io/posts/2016-03-25-highcharts-integration-in-elm.html))


## install
As this module uses native JS bindings, it cannot be published to the Elm package repository. If you want to use it clone the repo/download the source into your Elm project folder and add the folder as a source in `elm-package.json`

```
...
"source-directories": [
    "src", "elm-codemirror"
],

```

Currently it only supports basic features and is more of a proof of concept for embedding UI components that probably won't be written in pure Elm soon (I hope I'm wrong!).


## example
To see it action clone this repo and then:
```
$ cd example
$ elm make Main.elm --output=Main.js
$ open index.Html
```


See @sgillis's [elm-highcharts](https://github.com/sgillis/elm-highcharts) for another virtual-dom hook example with Elm
