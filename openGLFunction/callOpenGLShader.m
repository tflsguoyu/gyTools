% pixelCorresponding3Dpoints_HW3N = callOpenGLShader(vertexCoordinatesPerFaceA_3_3F_N, ...
%     vertexCoordinatesPerFaceB_3_3F_N, intrinsicMatrix_44, extrinsicMatrix_44, 1920, 1080);

function pixelCorresponding3Dpoints_HW3N = callOpenGLShader(...
    vertexCoordinatesPerFaceA_3_3F_N, ...
    vertexCoordinatesPerFaceB_3_3F_N, ...
    projectionMatrix, cameraMatrix, ...
    screenWidth, screenHeight)

% use of the GLSL OpenGL Shading language in the Psychtoolbox.

% Is the script running in OpenGL Psychtoolbox?
AssertOpenGL;

% Find the screen to use for display:
% screenid=max(Screen('Screens'));

% Disable Synctests for this simple demo:
Screen('Preference','SkipSyncTests',1);

% Setup Psychtoolbox for OpenGL 3D rendering support and initialize the
% mogl OpenGL for Matlab wrapper:
InitializeMatlabOpenGL(1,0);

% screenWidth = 1920;
% screenHeight = 1080;

% % Open a double-buffered not full-screen window on one displays screen.
% win = Screen('OpenWindow', 0 ,[0 127 0], [0 0 screenWidth screenHeight]);

% Using offline window to render mesh but need to show a window first
[~, ~] = Screen('OpenWindow', 0, [0 0 0], [0 0 screenWidth screenHeight]);
win = Screen('OpenOffscreenWindow', 0 ,[0 0 screenWidth screenHeight]);

% Make sure we run on a GLSL capable system. Abort if not.
AssertGLSL;

% Setup the OpenGL rendering context of the onscreen window for use by
% OpenGL wrapper. After this command, all following OpenGL commands will
% draw into the onscreen window 'win':
Screen('BeginOpenGL', win);

% Get the aspect ratio of the screen:
% ar=winRect(4)/winRect(3);

%% GL init

glEnable(GL_DEPTH_TEST);
glEnable(GL_NORMALIZE);

%% set up lighting and material properties

% Turn on OpenGL local lighting model: The lighting model supported by
% OpenGL is a local Phong model with Gouraud shading.
glEnable(GL_LIGHTING);

% Enable the first local light source GL_LIGHT_0. Each OpenGL
% implementation is guaranteed to support at least 8 light sources. 
glEnable(GL_LIGHT0);

% Enable two-sided lighting - Back sides of polygons are lit as well.
glLightModelfv(GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);

% Define the cubes light reflection properties by setting up reflection
% coefficients for ambient, diffuse and specular reflection:
glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT, [0.250000, 0.207250, 0.207250, 0.922000]);
glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE, [1.000000, 0.829000, 0.829000, 0.922000]);
glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR, [0.296648, 0.296648, 0.296648, 0.922000]);
glMaterialfv(GL_FRONT_AND_BACK,GL_SHININESS, 11.264000);

% Setup position and emission properties of the light source:
glLightfv(GL_LIGHT0,GL_POSITION,[ -100 -500 0 1 ]);
glLightfv(GL_LIGHT0,GL_DIFFUSE, [ 1 1 1 1 ]);
glLightfv(GL_LIGHT0,GL_SPECULAR, [ 1 1 1 1 ]);
glLightfv(GL_LIGHT0,GL_AMBIENT, [ 0 0 0 1 ]);
glLightModelfv(GL_LIGHT_MODEL_AMBIENT, [0.2, 0.2, 0.2, 1.0]);

%% set up camera and projection matrix

% get projection and camera matrix (vector)
% [projectionMatrix,~] = ... 
%     buildProjectionMatrix(screenWidth, screenHeight, ...
%     intrinsicParameters);

glMatrixMode(GL_PROJECTION);
glLoadIdentity;
glLoadMatrixd(projectionMatrix);

glMatrixMode(GL_MODELVIEW);
glLoadIdentity;
glLoadMatrixd(cameraMatrix);


%% GLSL setup:
glGetError;
str = which('callOpenGLShader');

shaderpath = [str(1:end-length('callOpenGLShader.m')) 'Shader\'];
glsl=LoadGLSLProgramFromFiles([shaderpath 'CamerafindCorrespondence'],1);
gluErrorString

% Activate program:
glUseProgram(glsl);
gluErrorString


%% initial FBO
% initFrameBufferDepthBuffer
fbo_depthID = glGenRenderbuffersEXT(1);
glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, fbo_depthID);
    glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT, screenWidth, screenHeight);
glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, 0);

% initFrameBufferTexture
fbo_textureID = glGenTextures(1);
glBindTexture(GL_TEXTURE_2D, fbo_textureID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, screenWidth, screenHeight, 0, GL_RGBA, GL_FLOAT, NaN(0));
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
glBindTexture(GL_TEXTURE_2D, 0);

%init FBO
fboID = glGenFramebuffersEXT(1);
glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fboID);
    glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, fbo_textureID, 0);
    glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, fbo_depthID);
glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);

status = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
if  status ~= GL_FRAMEBUFFER_COMPLETE_EXT
    disp('Could not create frame buffer');
end
        
%% inital VAO
vaoID = glGenVertexArrays(3);
% face
    glBindVertexArray(vaoID(1));    
        vbo_positionID = glGenBuffers(1);
        vbo_position2ID = glGenBuffers(1);
    glBindVertexArray(0);    
    

% for each pixel in frame A, it has a corresponding pixel in frame B
% frameA = 1; 
% frameB = 2;   
for i = 1: size(vertexCoordinatesPerFaceA_3_3F_N,2)
    
%% load frame A (vertex position)  
% face 
%     vertexA_3V = OBJfile(frameA).vertex_3V;
%     faceA_3F = OBJfile(frameA).face_3F;
% 
%     vertexCoordinatesPerFaceA_33F = ...
%         reshape( vertexA_3V( 1:3, faceA_3F(:) ), [3 3*size(faceA_3F,2)]);
vertexCoordinatesPerFaceA_33F = vertexCoordinatesPerFaceA_3_3F_N{i};

%% load frame B (vertex position)
% face
%     vertexB_3V = OBJfile(frameB).vertex_3V;
%     faceB_3F = OBJfile(frameB).face_3F;
% 
%     % vertexCoordinatesPerFace_33F contains the 3D coordinates (first dim)
%     % of the three vertices (second dim) of the F faces (third dim)
%     vertexCoordinatesPerFaceB_33F = ...
%         reshape( vertexB_3V( 1:3, faceB_3F(:) ), [3 3*size(faceB_3F,2)]);
vertexCoordinatesPerFaceB_33F = vertexCoordinatesPerFaceB_3_3F_N{i};


%% bind data (frame A vertex position; frame B vertex position) to vertex array
% face
glBindVertexArray(vaoID(1));   
    % bind reference vertex postion
    glBindBuffer(GL_ARRAY_BUFFER, vbo_positionID); 	
    glBufferData(GL_ARRAY_BUFFER, ...
        size(vertexCoordinatesPerFaceA_33F,1)*...
        size(vertexCoordinatesPerFaceA_33F,2)*8, ...
        vertexCoordinatesPerFaceA_33F, GL_STATIC_DRAW); 

    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_positionID);
    glVertexAttribPointer(0, 3, GL_DOUBLE, GL_FALSE, 0, 0); 

    glBindBuffer(GL_ARRAY_BUFFER, 0);

    % bind input vertex position 
    glBindBuffer(GL_ARRAY_BUFFER, vbo_position2ID); 	
    glBufferData(GL_ARRAY_BUFFER, ...
        size(vertexCoordinatesPerFaceB_33F,1)*...
        size(vertexCoordinatesPerFaceB_33F,2)*8, ...
        vertexCoordinatesPerFaceB_33F, GL_STATIC_DRAW); 

    glEnableVertexAttribArray(1);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_position2ID);
    glVertexAttribPointer(1, 3, GL_DOUBLE, GL_FALSE, 0, 0); 

    glBindBuffer(GL_ARRAY_BUFFER, 0);        

glBindVertexArray(0);  

%% find interest region: start_x, start_y, box_width, box_height
% input: vertex_3V; extrinsicParameters; intrinsicParameters;
% [start_x, start_y, rect_width, rect_height] = ...
% 	findInterestRegion(vertexA_3V, intrinsicParameters, ...
% 	screenWidth, screenHeight);   

%% draw vertex array and read back the data
glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fboID);

    glViewport(0, 0, screenWidth, screenHeight);
    glClearColor(0.0,0.5,0.0,1.0);
    glClearDepth(1.0);
    glClear;

    glEnable(GL_CULL_FACE);
    
% available = 0;
% queries = glGenQueries(3);
% glQueryCounter(queries(1), GL_TIMESTAMP);
 
    glBindVertexArray(vaoID(1));
        glDrawArrays(GL_TRIANGLES, 0, size(vertexCoordinatesPerFaceA_33F,2));  	
    glBindVertexArray(0);

% glQueryCounter(queries(2), GL_TIMESTAMP);    

%     data_rect = glReadPixels(start_x-1, start_y-1, rect_width, rect_height, GL_RGB, GL_FLOAT);
    data_rect = glReadPixels(0, 0, screenWidth, screenHeight, GL_RGB, GL_FLOAT);
      
% glQueryCounter(queries(3), GL_TIMESTAMP);        

% while ~available
%     available = glGetQueryObjectiv(queries(3), GL_QUERY_RESULT_AVAILABLE);
% end

% for i = 1:2
%     timeStart = glGetQueryObjectui64v(queries(i), GL_QUERY_RESULT);
%     timeEnd = glGetQueryObjectui64v(queries(i+1), GL_QUERY_RESULT);
%     timeElapsed = timeEnd - timeStart   
% end

    data = imrotate(double(data_rect), 90);
    
%     imageArray_HW3 = zeros(screenHeight, screenWidth, 3);
%     imageArray_HW3(:,:,2) = 0.5;
%     imageArray_HW3( screenHeight - start_y - rect_height + 2 : screenHeight - start_y + 1, ...
%         start_x : start_x + rect_width - 1, :) = data;
   
    pixelCorresponding3Dpoints_HW3N{i} = data;
  
glBindFramebufferEXT(GL_FRAMEBUFFER, 0);


% Finish OpenGL rendering into PTB window and check for OpenGL errors.
Screen('EndOpenGL', win);
    
%% finish 
% Close onscreen window and release all other ressources:
Screen('CloseAll');

% Reenable Synctests after this simple demo:
% Screen('Preference','SkipSyncTests',1);

% Well done!
end
