const Xvfb = require('xvfb.js');
const cypress = require('cypress')

process.env.CYPRESS_RUN_BINARY = '/var/task/lib/Cypress';
process.env.CYPRESS_CACHE_FOLDER = '/var/task/lib/Cypress';
process.env.XDG_CONFIG_HOME = '/var/task';

var xvfb = new Xvfb({
   xvfb_executable: './Xvfb',
   dry_run: false 
});

exports.handler = function(event, context) {
  xvfb.start((err, xvfbProcess) => {
			if (err) context.done(err);

			function done(err, result){
					xvfb.stop((err) => context.done(err, result));
			}

      cypress.run({
          spec: './cypress/integration/sample_spec.js',
          env: { 
            DEBUG: '*',
          },
          config: {
            video: false
          }
      })
      .then((results) => {
          console.log(results)
          done(null, results);
      })
      .catch((err) => {
          console.error(err)
          done(err);
      })
	});
}
