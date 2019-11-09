#!/bin/bash

read -p "Enter your score (0-100): " GRADE
if [ $GRADE -ge 85 ] && [ $GRADE -le 100 ]; then
	echo "$GRADE is Excellent"
elif [ $GRADE -ge 70 ] && [ $GRADE -le 84 ]; then
	echo "$GRADE is Pass"
else
	echo "$GRADE is Fail"
fi
