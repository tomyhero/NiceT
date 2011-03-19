use inc::Module::Install;
name 'NiceT';
all_from 'lib/NiceT.pm';

# requires '';

requires 'Pickles' => 0.06;

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_include;
WriteAll;
