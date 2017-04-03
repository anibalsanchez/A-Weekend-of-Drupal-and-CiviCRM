#!/bin/sh

aws ec2 start-instances --region $1 --instance-ids $2