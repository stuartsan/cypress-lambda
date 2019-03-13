const Xvfb = require("xvfb.js");
const cypress = require("cypress");
const child_process = require("child_process");
const mkdirp = require('mkdirp');

process.env.CYPRESS_RUN_BINARY = "/tmp/lib/Cypress";
process.env.CYPRESS_CACHE_FOLDER = "/tmp";
process.env.XDG_CONFIG_HOME = "/tmp";

var xvfb = new Xvfb({
  xvfb_executable: "./Xvfb",
  dry_run: false
});

let libExtracted = false;

exports.handler = function(event, context) {
  if (!libExtracted) {
    child_process.execSync("tar xzf ./lib.tar.gz -C /tmp");
    libExtracted = true;
  }

  xvfb.start((err, xvfbProcess) => {
    if (err) context.done(err);

    function done(err, result) {
      xvfb.stop(err => context.done(err, result));
    }

    cypress
      .run({
        spec: "./cypress/integration/sample_spec.js",
        env: {
          // DEBUG: "cypress:*"
        },
        config: {
          video: false
        }
      })
      .then(results => {
        console.log(results);
        done(null, results);
      })
      .catch(err => {
        console.error(err);
        done(err);
      });
  });
};
