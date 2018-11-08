#!/bin/bash

function pr_err()
{
	echo "Error:$1";
}

function pr_err_exit()
{
	pr_err $1;
	exit 1;
}

function assert_equal()
{
	if [[ $1 == $2 ]]; then
	       pr_err_exit $3
	fi
}

function assert_unequal()
{
	if [[ ! $1 == $2 ]]; then
		pr_err_exit $3
	fi
}
