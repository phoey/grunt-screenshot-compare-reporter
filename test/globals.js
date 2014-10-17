var path              = require("path");
global.sinon          = require('sinon');
global.chai           = require('chai');
global.expect        = chai.expect;
global.srcFile       = path.resolve(__dirname, "../src");
global.injector      = require(path.join(global.srcFile, "/injector"));
process.env.NODE_ENV = "test";