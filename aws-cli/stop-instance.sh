#!/bin/sh

aws ec2 stop-instances --region $1 --instance-ids $2