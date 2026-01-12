% Read and resize image
img = imread('test.jpeg');
img = imresize(img, [360 480]);   % [height width]

% Open COE file for writing
fid = fopen('image.coe', 'w');

% Write COE header
fprintf(fid, 'memory_initialization_radix=16;\n');
fprintf(fid, 'memory_initialization_vector=\n');

% Get image size
[rows, cols, ~] = size(img);

% Write pixel data (RRGGBB format)
for i = 1:rows
    for j = 1:cols
        r = img(i, j, 1);
        g = img(i, j, 2);
        b = img(i, j, 3);

        fprintf(fid, '%02x%02x%02x,\n', r, g, b);
    end
end

% Close file
fclose(fid);
