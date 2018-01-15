% sigmaX_test.m - unit tests for sigmaX components
% Richard M. Murray, 14 Jan 2018

% Set up a standard set of TX-TL tubes
tube1 = txtl_extract('E30VNPRL');
tube2 = txtl_buffer('E30VNPRL');

% Create a tube that will contain our DNA
tube3 = txtl_newtube('gene_expression');

% Define the DNA strands (defines TX-TL species + reactions)
txtl_add_dna(tube3, ...
  'p70(50)', 'utr1(20)', 'sigmaX(1000)', ...	% promoter, rbs, gene
   30, ...					% concentration (nM)
  'plasmid');					% type
txtl_add_dna(tube3, ...
  'psigX(50)', 'utr1(20)', 'deGFP(1000)', ...	% promoter, rbs, gene
   30, ...					% concentration (nM)
  'plasmid');					% type

% Mix the contents of the individual tubes
Mobj = txtl_combine([tube1, tube2, tube3]);

%
% Run a simulaton
%
% At this point, the entire experiment is set up and loaded into 'Mobj'.
% So now we just use standard Simbiology and MATLAB commands to run
% and plot our results!
%

[simData] = txtl_runsim(Mobj,14*60*60);

% plot the result
txtl_plot(simData,Mobj);

% Automatically use matlab mode in emacs (keep at end of file)
% Local variables:
% mode: matlab
% End:
