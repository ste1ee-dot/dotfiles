#!/bin/sh

stow . --adopt &&
git restore . &&
stow .
