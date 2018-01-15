% txtl_protein_sigmaX.m - protein information for sigmaX factor
% Richard M. Murray, 14 Jan 2018 (based on sigma28 by Z. Tuza)
%
% This file contains a description of the protein produced by sigmaX.
% Calling the function txtl_protein_sigmaX() will set up the reactions
% for binding to RNA polymerase.  Binding reactions for promoters
% should be give in the txtl_promoter_* files that use sigmaX.

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

function varargout = txtl_protein_sigmaX(mode, tube, protein, varargin)

% importing the corresponding parameters
paramObj = txtl_component_config('sigmaX');

%%%%%%%%%%%%%%%%%%% DRIVER MODE: Setup Species %%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(mode.add_dna_driver, 'Setup Species')
    
    geneData = varargin{1};
    defaultBasePairs = {'sigmaX', 'lva', 'terminator'; ...
        paramObj.Gene_Length, paramObj.LVA_tag_Length, ...
        paramObj.Terminator_Length};
    geneData = txtl_setup_default_basepair_length(tube, geneData, ...
        defaultBasePairs);
    
    varargout{1} = geneData;

    coreSpecies = {'RNAP','RNAPSIGX'};
    % empty cellarray for amount => zero amount
    txtl_addspecies(tube, coreSpecies, cell(1,size(coreSpecies,2)), 'Internal');
    
%%%%%%%%%%%%%%%%%%% DRIVER MODE: Setup Reactions %%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(mode.add_dna_driver, 'Setup Reactions')
    
    %sequestration of RNAP by sigmaX factor
    txtl_addreaction(tube,['RNAP + [' protein.Name '] <-> RNAPSIGX'], ...
         'MassAction', {'SigmaX_RNAP_F', paramObj.non_s70_factor_Forward; ...
                        'SigmaX_RNAP_R', paramObj.non_s70_factor_Reverse});
                   
%%%%%%%%%%%%%%%%%%% DRIVER MODE: error handling %%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    error('txtltoolbox:txtl_protein_sigmaX:undefinedmode', ...
      'The possible modes are ''Setup Species'' and ''Setup Reactions''.');
end     

% Automatically use MATLAB mode in Emacs (keep at end of file)
% Local variables:
% mode: matlab
% End:
