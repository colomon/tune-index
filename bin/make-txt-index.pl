use v6;
# use Grammar::Tracer;

sub infix:<++> ($a, $b) {
    my @ = $a.values, $b.values;
}

class TuneIndex {
    has Rat $.index;
    has Str $.name;
    has %.info;
    
    method names() {
        self.name ++ self.info<AKA> ++ self.info<GIVEN>;
    }
}

grammar TuneIndex::Grammar {
    rule TOP {
        <tune>+
    }
    
    rule tune {
        <index> <name>
        <info>* % \v
    }
    
    token index {
        \d+ '.' \d
    }
    
    token name {
        \V+ $$
    }
    
    token info {
        <key> <.ws> <name>
    }
    
    token key {
        < C GIVEN AKA NOTE >
    }
}

my %tunes;

class TuneIndex::Actions {
    method tune($/) {
        my %info;
        for $<info>.list -> $i {
            %info{$i.ast.key}.push($i.ast.value);
        }
        
        my $index = $<index>.ast;
        die "Tune $index already exists" if %tunes{$index}:exists;
        %tunes{$index} = TuneIndex.new(:$index,
                                       name => $<name>.ast,
                                       info => %info);
    }
    
    method index($/) {
        make (~$/).Rat
    }
    
    method info($/) {
        make ~$<key> => $<name>.ast
    }
    
    method name($/) {
        make $/.chomp
    }
}

TuneIndex::Grammar.parse(slurp("trip-to-sligo"), :actions(TuneIndex::Actions.new)) or die "Unable to parse trip-to-sligo";

sub sortable-name($_) {
    when /^The \s+ (.*)$/ { $0 ~ ", The" }
    default { $_ }
}

my %names;
for %tunes.kv -> $index, $tune {
    for $tune.names -> $name {
        %names{sortable-name($name)}.push($index);
    }
}

for %names.keys.sort -> $name {
    say $name ~ ": " ~ %names{$name}.join(", ");
}

