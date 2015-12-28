use v6;
use TuneIndex;

my $tunes = TuneIndex::Actions.new;
TuneIndex::Grammar.parse(slurp("trip-to-sligo"), :actions($tunes)) or die "Unable to parse trip-to-sligo";

for $tunes.tunes.pairs.sort(+*.key) -> $tune {
    my $composer = $tune.value.composer ?? "(" ~ $tune.value.composer ~ ")" !! "";
    say "{ $tune.key } { $tune.value.name } $composer";
}
