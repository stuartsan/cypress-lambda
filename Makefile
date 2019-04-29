pre:
	npm i
	

deploy:
	touch lambda.zip
	terraform init
	terraform apply --auto-approve 

test:
	npm test
