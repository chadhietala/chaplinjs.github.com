#!/usr/bin/env ruby

puts 'Remove old generated files ================='
`find . -depth \
 -path "./jekyll" -prune -o \
 -path "./jekyll/*" -prune -o \
 -path "./.git" -prune -o \
 -path "./.git/*" -prune -o \
 ! -name deploy.rb \
 ! -name ".git*" \
 ! -name "README.md" \
 -delete`

puts "\nCopy new generated files ==================="
`cp -rf jekyll/_site/* ./`

puts "\nCommit the files to git ===================="
`git add .`
`git reset -- jekyll/*`
`git reset -- deploy.rb`
`git commit -m "Update Jekyll generated HTML"`

puts "\nDeploy to github ==========================="
`git push origin master`