module.exports = {
  build: {
    "index.html": "index.html",
    "app.js": [
      "javascripts/app.js",
      "javascripts/lightwallet.min.js"
    ],

    "app.css": [
      "stylesheets/app.css"
    ],
    "images/": "images/"
  },
  deploy: [
    "BTCLotto"
  ],
  rpc: {
    host: "localhost",
    port: 8545
  }
};
