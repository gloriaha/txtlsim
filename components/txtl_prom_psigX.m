% txtl_prom_psigX.m - promoter information for psigX promoter
% Richard M. Murray, 14 Jan 2018
%
% This file contains a description of the psigX promoter.
% Calling the function txtl_prom_psigX() will set up the reactions for
% transcription with the measured binding rates and transription rates.
%
% This file is bsed on txtl_prom_p28.m.

%
% Copyright (c) 2018 by California Institute of Technology
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%   1. Redistributions of source code must retain the above copyright
%      notice, this list of conditions and the following disclaimer.
%
%   2. Redistributions in binary form must reproduce the above copyright
%      notice, this list of conditions and the following disclaimer in the
%      documentation and/or other materials provided with the distribution.
%
%   3. The name of the author may not be used to endorse or promote products
%      derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
% IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
% INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
% IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

function varargout = txtl_prom_psigX(mode, tube, dna, rna, varargin)

% Create strings for reactants and products
DNA = ['[' dna.Name ']'];		% DNA species name for reactions
RNA = ['[' rna.Name ']'];		% RNA species name for reactions
RNAP = 'RNAPSIGX';			% RNA polymerase name for reactions
RNAPbound = ['RNAPSIGX:' dna.Name];
% importing the corresponding parameters
paramObj = txtl_component_config('sigmaX');

%%%%%%%%%%%%%%%%%%% DRIVER MODE: Setup Species %%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(mode.add_dna_driver, 'Setup Species')
    
    promoterData = varargin{1};
    if nargin==8
        prom_spec = varargin{2};
        rbs_spec = varargin{3};
        gene_spec = varargin{4};
    elseif nargin~=5
        error('the number of argument should be 5 or 8, not %d',nargin);
    end
    defaultBasePairs = {'psigX', 'junk', 'thio'; ...
        paramObj.Promoter_Length, paramObj.Junk_Length, paramObj.Thio_Length};
    promoterData = txtl_setup_default_basepair_length(tube, promoterData, ...
        defaultBasePairs);
    
    varargout{1} = promoterData;
    
    coreSpecies = {RNAP,RNAPbound};
    % empty cellarray for amount => zero amount
    txtl_addspecies(tube, coreSpecies, cell(1,size(coreSpecies,2)), 'Internal');
    
    %%%%%%%%%%%%%%%%%%% DRIVER MODE: Setup Reactions %%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(mode.add_dna_driver,'Setup Reactions')
    listOfSpecies = varargin{1};
    if nargin==8
        prom_spec = varargin{2};
        rbs_spec = varargin{3};
        gene_spec = varargin{4};
    elseif nargin~=5
        error('the number of argument should be 5 or 8, not %d',nargin);
    end
    parameters = {'TXTL_SIGX_RNAPbound_F',paramObj.RNAPbound_Forward;...
        'TXTL_SIGX_RNAPbound_R',paramObj.RNAPbound_Reverse};
    % Set up binding reaction
    txtl_addreaction(tube, [DNA ' + ' RNAP ' <-> [' RNAPbound ']'], ...
        'MassAction', parameters);
    txtl_transcription(mode, tube, dna, rna, RNAP, RNAPbound);
    
    %%%%%%%%%%%%%%%%%%% DRIVER MODE: error handling %%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    error('txtltoolbox:txtl_prom_psigX:undefinedmode', ...
        'The possible modes are ''Setup Species'' and ''Setup Reactions''.');
end


% Automatically use MATLAB mode in Emacs (keep at end of file)
% Local variables:
% mode: matlab
% End:
