use v6;
use TuneIndex;

my $tunes = TuneIndex::Actions.new;
TuneIndex::Grammar.parse(slurp("trip-to-sligo"), :actions($tunes)) or die "Unable to parse trip-to-sligo";

sub sortable-name($_) {
    when /^The \s+ (.*)$/ { $0 ~ ", The" }
    default { $_ }
}

my %names;
for $tunes.tunes.kv -> $index, $tune {
    for $tune.names -> $name {
        %names{sortable-name($name)}.push($index);
    }
}

for %names.keys.sort -> $name {
    say $name ~ ": " ~ %names{$name}.join(", ");
}

