Elm.Native = Elm.Native || {};
Elm.Native.CodeMirror = Elm.Native.CodeMirror || {};


Elm.Native.CodeMirror.make = function(elm) {
  'use strict';
  elm.Native = elm.Native || {};
  elm.Native.CodeMirror = elm.Native.CodeMirror || {};
  if (elm.Native.CodeMirror.values) return elm.Native.CodeMirror.values;

  var VirtualDom = Elm.Native.VirtualDom.make(elm);
  var List = Elm.Native.List.make(elm);
  var Signal = Elm.Native.Signal.make(elm);

  var objectComparison = function(obj1, obj2){
    return JSON.stringify(obj1) == JSON.stringify(obj2);
  };

  var Hook = function(config, msgCreator) {
    this.config = config;
    this.msgCreator = msgCreator;
    this.codeMirror = undefined;
  };


  // function on(createMessage) {
  //   function eventHandler(event) {
  //     var value = A2(Json.runDecoderValue, decoder, event);
  //     if (value.ctor === 'Ok') {
  //       if (options.stopPropagation) {
  //         event.stopPropagation();
  //       }
  //       if (options.preventDefault) {
  //         event.preventDefault();
  //       }
  //     }
  //   }
  //   return property('on' + name, eventHandler);
  // }

  Hook.prototype.initialize = function(node, propertyName, previousValue) {
    var hook = this;

    if (typeof CodeMirror === "undefined") {
      throw new Error ("CodeMirror was not found. Please make sure to include it in your html file");
    }

    this.codeMirror = CodeMirror(node, this.config.cmConfig);
    this.codeMirror.setValue(this.config.value);
    setTimeout(function () {
      hook.codeMirror.refresh();
    }, 1);

    this.codeMirror.on('change', function () {
      Signal.sendMessage(hook.msgCreator(hook.codeMirror.getValue()));
    });
  };

  Hook.prototype.setNewValue = function(node, propertyName, previousValue) {
    var cm = this.codeMirror;
    var config = this.config.cmConfig;
    var prevConfig = previousValue.config.cmConfig;

    //prevents losing cursor position when typing in a code mirror instance that is set to update the model it is bound to
    if (cm.getValue() !== config.value && !cm.hasFocus()) {
      cm.setValue(this.config.value);
    }

    Object.keys(config)
      .forEach(function (key) {
        var curr = config[key];
        var prev = prevConfig[key];
        if (curr !== prev) {
          cm.setOption(key, curr);
        }
      });
  };

  Hook.prototype.update = function(node, propertyName, previousValue) {
    this.codeMirror = previousValue.codeMirror;
    this.setNewValue(node, propertyName, previousValue);
  };

  Hook.prototype.hook = function(node, propertyName, previousValue) {
    if (previousValue === undefined || previousValue.codeMirror === undefined) {
      this.initialize(node, propertyName, previousValue);
    } else {
      this.update(node, propertyName, previousValue);
    }
  };

  function codeMirror(config, createMsg) {
    var propertyList = List.fromArray(
      [{
        key: "codemirror-hook",
        value: new Hook(config, createMsg)
      }]
    );
    var node =
      A3(VirtualDom.node, "codemirror", propertyList, List.fromArray([]));
    return node;
  }

  return elm.Native.CodeMirror.values = {
    codeMirror: F2(codeMirror)
  };
};
