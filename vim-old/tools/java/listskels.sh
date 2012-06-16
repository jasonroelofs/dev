#!/bin/sh
ls ~/.jpath/skels/*.skel | sed -e 's/\.skel//' | sed -e 's/.*\///'
