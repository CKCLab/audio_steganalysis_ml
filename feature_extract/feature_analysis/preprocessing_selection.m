%% selection of preprocessing methods 
%       via euclidean distance, cosine similarity, Pearson correlation and Kullback-Leibler divergence
%#ok<*SEPEX>

T = 5;
file_num = 1;

preprocessing_methods = {'origin', 'dif1_h', 'dif1_v', 'dif2_h', 'dif2_v', 'abs_dif1_h', 'abs_dif1_v', 'abs_dif2_h', 'abs_dif2_v'};
data_cover_path = 'E:\Myself\2.database\mtap\txt\cover\128';
data_stego_path = 'E:\Myself\2.database\mtap\txt\stego\EECS\EECS_B_128_W_2_H_7_ER_10';

[cover_files_list, ~] = get_files_list(data_cover_path, 'txt');
[stego_files_list, ~] = get_files_list(data_stego_path, 'txt');

for i = 1:length(preprocessing_methods)
    preprocessing_method = preprocessing_methods{i};
    [euclidean_distance, cosine, pearson_correlation, KL] = deal(0, 0, 0, 0);
    
    for f = 1:file_num
        cover_file_path = fullfile(data_cover_path, cover_files_list{f});
        stego_file_path = fullfile(data_stego_path, stego_files_list{f});
        
        cover = load(cover_file_path);
        stego = load(stego_file_path);
        distance = get_distance(cover, stego, preprocessing_method, T);
        
        euclidean_distance  = euclidean_distance + distance.euclidean_distance;
        cosine = cosine + distance.cosine;
        pearson_correlation = pearson_correlation + distance.pearson_correlation;
        KL = KL + distance.KL;
    end
    
    fprintf('=============================\n');
    fprintf('%s:\n', preprocessing_method);
    fprintf('Euclidean Distance : %.5f\n', euclidean_distance / file_num);
    fprintf('Cosine Similarity  : %.5f\n', cosine / file_num);
    fprintf('Pearson Correlation: %.5f\n', pearson_correlation / file_num);
    fprintf('KullbackĘCLeibler divergence: %.5f\n', KL / file_num);
end

% distance = get_distance(matrix_cover, matrix_stego, preprocessing_method, T)
% - Variable:
% ------------------------------------------input
% matrix_cover              cover QMDCT coefficients matrix
% matrix_stego              stego QMDCT coefficients matrix
% -----------------------------------------output
% distance
%   euclidean_distance       euclidean distance
%   cosine                   cosine similarity
%   pearson_correlation      Pearson correlation
%   KL                       KullbackĘCLeibler divergence

function distance = get_distance(matrix_cover, matrix_stego, preprocessing_method, T)

if strcmp(preprocessing_method, 'origin') new_matrix_cover = matrix_cover;new_matrix_stego = matrix_stego;end

if strcmp(preprocessing_method, 'dif1_h') new_matrix_cover = pre_process_matrix(matrix_cover, 'dif1_h');new_matrix_stego = pre_process_matrix(matrix_stego, 'dif1_h');end
if strcmp(preprocessing_method, 'dif1_v') new_matrix_cover = pre_process_matrix(matrix_cover, 'dif1_v');new_matrix_stego = pre_process_matrix(matrix_stego, 'dif1_v');end
if strcmp(preprocessing_method, 'dif2_h') new_matrix_cover = pre_process_matrix(matrix_cover, 'dif2_h');new_matrix_stego = pre_process_matrix(matrix_stego, 'dif2_h');end
if strcmp(preprocessing_method, 'dif2_v') new_matrix_cover = pre_process_matrix(matrix_cover, 'dif2_v');new_matrix_stego = pre_process_matrix(matrix_stego, 'dif2_v');end

if strcmp(preprocessing_method, 'abs_dif1_h') new_matrix_cover = pre_process_matrix(matrix_cover, 'abs_dif1_h');new_matrix_stego = pre_process_matrix(matrix_stego, 'abs_dif1_h');end
if strcmp(preprocessing_method, 'abs_dif1_v') new_matrix_cover = pre_process_matrix(matrix_cover, 'abs_dif1_v');new_matrix_stego = pre_process_matrix(matrix_stego, 'abs_dif1_v');end
if strcmp(preprocessing_method, 'abs_dif2_h') new_matrix_cover = pre_process_matrix(matrix_cover, 'abs_dif2_h');new_matrix_stego = pre_process_matrix(matrix_stego, 'abs_dif2_h');end
if strcmp(preprocessing_method, 'abs_dif2_v') new_matrix_cover = pre_process_matrix(matrix_cover, 'abs_dif2_v');new_matrix_stego = pre_process_matrix(matrix_stego, 'abs_dif2_v');end

if strcmp(preprocessing_method, 'interval_row') new_matrix_cover = pre_process_matrix(matrix_cover, 'interval_row');new_matrix_stego = pre_process_matrix(matrix_stego, 'interval_row');end
if strcmp(preprocessing_method, 'interval_col') new_matrix_cover = pre_process_matrix(matrix_cover, 'interval_col');new_matrix_stego = pre_process_matrix(matrix_stego, 'interval_col');end

if strcmp(preprocessing_method, 'kv') new_matrix_cover = pre_process_matrix(matrix_cover, 'kv');new_matrix_stego = pre_process_matrix(matrix_stego, 'kv');end

% feature extraction
feature_cover = get_point_block_markov(new_matrix_cover, T);
feature_stego = get_point_block_markov(new_matrix_stego, T);

% euclidean distance
distance.euclidean_distance = get_vector_distance(feature_cover, feature_stego, 'Euclidean');

% cosine similarity
distance.cosine = get_vector_distance(feature_cover, feature_stego, 'Cosine');

% Pearson correlation
distance.pearson_correlation = get_vector_distance(feature_cover, feature_stego, 'Pearson');

% Kullback-Leibler divergence
distance.KL = get_prob_vector_distance(feature_cover, feature_stego, 'Relative_Entropy');

end