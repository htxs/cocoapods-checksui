A checklist for releasing the Gem:

* Test: `rake`
* Bump version in lib/cocoapod_check_sui.rb
* Commit
* `git tag x.y.z`
* `git push`
* `git push --tags`
* `gem build cocoapods-checksui.gemspec`
* `gem push cocoapods-checksui-x.y.z.gem`
* Create release on GitHub from tag
