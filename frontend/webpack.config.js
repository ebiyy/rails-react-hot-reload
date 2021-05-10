const glob = require("glob");
const path = require("path");
const { WebpackManifestPlugin } = require("webpack-manifest-plugin");

let entries = {};
glob.sync("./entries/*.js").map((file) => {
  let name = file.split("/")[2].split(".")[0];
  entries[name] = file;
});

module.exports = {
  mode: "development",
  entry: entries,
  output: {
    filename: "javascripts/[name]-[hash].js",
    path: path.resolve(__dirname, "../public/assets"),
  },
  plugins: [
    new WebpackManifestPlugin({
      fileName: "manifest.json",
      publicPath: "/assets/",
      writeToFileEmit: true,
    }),
  ],
  devServer: {
    host: "localhost",
    port: 3035,
    publicPath: "http://localhost:3035/assets/",
    contentBase: path.resolve(__dirname, "../public/assets"),
    hot: true,
    disableHostCheck: true,
    historyApiFallback: true,
  },
  module: {
    rules: [
      {
        test: /\.(ts|tsx)$/,
        use: "ts-loader",
      },
      {
        test: /\.(png|jpg|gif)$/i,
        use: [
          {
            loader: "file-loader",
            options: {
              outputPath: "images",
              publicPath: function (path) {
                return "images/" + path;
              },
              name: "[name]-[hash].[ext]",
            },
          },
        ],
      },
    ],
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js", ".jsx"],
  },
};
