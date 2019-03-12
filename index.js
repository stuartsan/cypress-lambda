const Xvfb = require('xvfb.js');

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

			console.log('hi');
			done(null, { foo: 'bar' });
	});
}
