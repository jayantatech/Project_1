APP_NAME="JAY_APP"
VERSION="1.0.0"

echo "This is the build file"

FILE_PATH="logs/file_one.txt"

NODE_VERSION=$(node -v)

if [[ -f $FILE_PATH  ]]; then 

echo "file exist"
rm -rf $FILE_PATH

else echo "File does not exist"

fi

echo "Node version is $NODE_VERSION"