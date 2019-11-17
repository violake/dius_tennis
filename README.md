# Match
This is a scoring system for a tennis tournament

## How to Run

```bash
# install gems
bundle install

# test
# coverage/index.html shows test coverage details
bundle exec rspec

# code format
bundle exec rubocop

# usage
irb
$LOAD_PATH.unshift('./lib')
require 'match'

match = Match.new('player_1', 'player_2')
match.point_won_by('player_1')
match.point_won_by('player_2')
# this will return "0-0, 15-15"
match.score

```