## AWS Lambda Racket Runtime

Racket implementation of the lambda runtime API. It uses a Minimal Racket distribution.

The purpose of this repository is to understand how to implement a custom AWS Lambda runtime.

If you just want to run your racket code in Lambda, there is a publickly available layer you can use with arn *arn:aws:lambda:ap-northeast-2:389941452291:layer:lambda-racket-runtime:21*.

Please be noted that the layer's version would be changed and it hopefully will be updated as a new version is available.

It does not support error-handling at the moment.

## Building and Deploying the Runtime

### Build
To build the runtime, you need a Docker environment. You can use free tier eligible AWS EC2 instance for this.

```bash
$ git clone https://github.com/kpiljoong/lambda-racket-runtime.git
$ cd lambda-racket-runtime
$ make build
```

### Create the runtime archive
This will make a 'lambda-racket-runtime.zip' file for you.

```bash
$ make archive
```

### Publish layer
Publish a layer containing the runtime.

```bash
$ aws lambda publish-layer-version --layer-name lambda-racket-runtime --zip-file fileb://lambda-racket-runtime.zip
```

The output will show you the *LayerVersionArn*.

### Test the runtime

1. Make an archive of a test file
```bash
$ make demo-archive
```

2. Create a test Lambda function (you need a IAM role for the function)
```bash
$ aws lambda create-function --function-name racket-demo --role LAMBDA_ROLE_ARN --runtime provided --timeout 15 --memory-size 128 --handler demo:main --zip-file fileb://racket-demo.zip
```

3. Add the layer to the function
```bash
$ aws lambda update-function-configuration --function-name racket-demo --layers LAYER_VERSION_ARN
```

4. Invoke the function
```bash
$ aws lambda invoke --function-name racket-demo --payload '' output.json
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
$ cat output.json
Hello AWS! Happy coding!!
```

