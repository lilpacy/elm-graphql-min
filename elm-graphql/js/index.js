require('../css/style.css');
const { Elm } = require('../example/Main.elm');

var app = Elm.Main.init({
  node: document.getElementById('elm')
});
