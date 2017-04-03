#!/bin/sh

aws ec2 describe-instance-status --region $1 --instance-ids $2