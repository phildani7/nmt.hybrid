function [softmax_h, input, attn_h_concat, alignWeights, alignScores] = lstm2softHid(h_t, params, model, varargin)
%%%
%
% From lstm hidden state to softmax hidden state.
%
% Thang Luong @ 2015, <lmthang@stanford.edu>
%
%%%
  if params.softmaxDim>0 % compression: f(W_h * h_t)
    softmax_h = params.nonlinear_f(model.W_h*h_t);
  elseif params.attnFunc>0 % attention mechanism
    srcHidVecs = varargin{1};
    curMask = varargin{2};

    [softmax_h, attn_h_concat, alignWeights, alignScores, input] = attnForward(h_t, model, params, srcHidVecs, curMask);
  elseif params.posModel==3 % positional model: f(W_h * [srcPosVecs; h_t])
    input = [varargin{1}; h_t];
    softmax_h = params.nonlinear_f(model.W_h*input);
  else % normal
    softmax_h = h_t;
  end
end