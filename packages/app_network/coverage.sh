flutter test --coverage

# Note: on macOS you need to have lcov installed on your system (`brew install lcov`) to use this
genhtml coverage/lcov.info -o coverage/html

open coverage/html/index.html