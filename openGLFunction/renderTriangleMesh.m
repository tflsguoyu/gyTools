function renderTriangleMesh(OBJfile, meshColor,...
    projectionMatrix, cameraMatrix, screenWidth, screenHeight, ...
    renderedMeshFolderName, frames)
% use of the GLSL OpenGL Shading language in the Psychtoolbox.

% Is the script running in OpenGL Psychtoolbox?
AssertOpenGL;

% Find the screen to use for display:
% screenid=max(Screen('Screens'));

% Disable Synctests for this simple demo:
Screen('Preference','SkipSyncTests',1);

% Setup Psychtoolbox for OpenGL 3D rendering support and initialize the
% mogl OpenGL for Matlab wrapper:
InitializeMatlabOpenGL(1,3);

% screenWidth = 1920;
% screenHeight = 1080;

% % Open a double-buffered not full-screen window on one displays screen.
win = Screen('OpenWindow', 0 ,[0 127 0], [0 0 screenWidth screenHeight]);

% Using offline window to render mesh but need to show a window first
% winRect = [0 0 1920 1080];
% [~ , ~] = Screen('OpenWindow', screenid, [0 0 0], winRect);
% [win , ~] = Screen('OpenOffscreenWindow', screenid ,[0 127 0], winRect);

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
% glEnable(GL_LIGHTING);

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

% color of Heiyaoshi
glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT, [0.053750, 0.050000, 0.066250, 0.820000]);
glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE, [0.182750, 0.170000, 0.225250, 0.820000]);
glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR, [0.332741, 0.328634, 0.346435, 0.820000]);
glMaterialfv(GL_FRONT_AND_BACK,GL_SHININESS, 38.400002);


% Setup position and emission properties of the light source:
glLightfv(GL_LIGHT0,GL_POSITION,[ -100 -500 0 1 ]);
glLightfv(GL_LIGHT0,GL_DIFFUSE, [ 1 1 1 1 ]);
glLightfv(GL_LIGHT0,GL_SPECULAR, [ 1 1 1 1 ]);
glLightfv(GL_LIGHT0,GL_AMBIENT, [ 0 0 0 1 ]);
glLightModelfv(GL_LIGHT_MODEL_AMBIENT, [0.2, 0.2, 0.2, 1.0]);

%% set up camera and projection matrix

% get projection and camera matrix (vector)
glMatrixMode(GL_PROJECTION);
glLoadIdentity;
glLoadMatrixd(projectionMatrix);

glMatrixMode(GL_MODELVIEW);
glLoadIdentity;
glLoadMatrixd(cameraMatrix);


%% GLSL setup:
% glGetError;
% 
% renderMesh_PATH = which('renderMesh');
% renderMesh_PATH = renderMesh_PATH(1:end-12);
% shaderpath = 'Shader\';
% glsl=LoadGLSLProgramFromFiles([renderMesh_PATH shaderpath 'CameraPhongmethod_vertexarray'],1);
% gluErrorString
% 
% % Activate program:
% glUseProgram(glsl);
% gluErrorString

%% inital VAO
	vaoID = glGenVertexArrays(3);
% face 
	glBindVertexArray(vaoID(1));    
        vbo_positionID = glGenBuffers(1);
%         vbo_normalID = glGenBuffers(1);
    glBindVertexArray(0);
    
%% rendering mesh
count = 1;
for frameNumber = frames;
tic
%% load vertex data (position, normal, position2)
%     
% face    
    vertex_3V = OBJfile(frameNumber).vertex_3V;
    face_3F = OBJfile(frameNumber).face_3F;
%     face_3F(:,end-31:end) = [];
%     faceNormal_3F = getFaceNormal(vertex_3V,face_3F);
%     vertexNormal_3V = getVertexNormal(vertex_3V,face_3F,faceNormal_3F);  
    
    % vertexCoordinatesPerFace_33F contains the 3D coordinates (first dim)
	% of the three vertices (second dim) of the F faces (third dim)
    vertexCoordinatesPerFace_33F = ...
        reshape( vertex_3V( 1:3, face_3F(:) ), [3 3*size(face_3F,2)]);

%     vertexNormalCoordinatesPerFace_33F = ...
%         reshape( vertexNormal_3V( 1:3, face_3F(:) ), [3 3*size(face_3F,2)]);
        
%% bind data to vertex array
% face
    glBindVertexArray(vaoID(1));   

        % bind vertex postion
        glBindBuffer(GL_ARRAY_BUFFER, vbo_positionID); 	
        glBufferData(GL_ARRAY_BUFFER, ...
            size(vertexCoordinatesPerFace_33F,1)*...
            size(vertexCoordinatesPerFace_33F,2)*8, ...
            vertexCoordinatesPerFace_33F, GL_STATIC_DRAW); 

        glEnableVertexAttribArray(0);
        glBindBuffer(GL_ARRAY_BUFFER, vbo_positionID);
        glVertexAttribPointer(0, 3, GL_DOUBLE, GL_FALSE, 0, 0); 

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        % bind vertex normal
%         glBindBuffer(GL_ARRAY_BUFFER, vbo_normalID); 	
%         glBufferData(GL_ARRAY_BUFFER, ...
%             size(vertexNormalCoordinatesPerFace_33F,1)*...
%             size(vertexNormalCoordinatesPerFace_33F,2)*8, ...
%             vertexNormalCoordinatesPerFace_33F, GL_STATIC_DRAW); 
% 
%         glEnableVertexAttribArray(1);
%         glBindBuffer(GL_ARRAY_BUFFER, vbo_normalID);
%         glVertexAttribPointer(1, 3, GL_DOUBLE, GL_FALSE, 0, 0); 
% 
%         glBindBuffer(GL_ARRAY_BUFFER, 0);   
    
    glBindVertexArray(0);  
   
%% Draw array
    glViewport(0, 0, screenWidth, screenHeight);
    glClearColor(0.0,0.5,0.0,1.0);
    glClearDepth(GL_DEPTH_BUFFER_BIT);
    glClear;

 
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);

    % step1: render wireframe
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    glColor3f(meshColor(1), meshColor(2), meshColor(3));
    glLineWidth(1);
    glBindVertexArray(vaoID(1));
        glDrawArrays(GL_TRIANGLES, 0, 3*size(face_3F,2));  	
    glBindVertexArray(0);
    
    % step 2: render filled mesh with a little offset
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    glEnable(GL_POLYGON_OFFSET_FILL);
    glPolygonOffset( 1, 1 );
    glColor3f(0,0.5,0);
    glBindVertexArray(vaoID(1));
        glDrawArrays(GL_TRIANGLES, 0, 3*size(face_3F,2));  	
    glBindVertexArray(0);    

    
%% read back the data
%     data = glReadPixels(500, 0, 1000, 1000, GL_RGB, GL_FLOAT);
    data = glReadPixels(0, 0, screenWidth, screenHeight, GL_RGB, GL_FLOAT);
    imageArray_HW3 = imrotate(double(data), 90);
%     imshow(imageArray_HW3);

    filename = sprintf('mesh_%05d.png',frameNumber);
    if exist(renderedMeshFolderName,'dir')~=7
     mkdir(renderedMeshFolderName);
    end
    imwrite(imageArray_HW3, fullfile(renderedMeshFolderName,filename));
    count = count + 1;
%%
    % Finish OpenGL rendering into PTB window and check for OpenGL errors.
    Screen('EndOpenGL', win);
     
	% Show rendered image at next vertical retrace:
    Screen('Flip', win);
  
    % Switch to OpenGL rendering again for drawing of next frame:
    Screen('BeginOpenGL', win);
    
    % Check for keyboard press and exit, if so:
    [keydown secs keycode]=KbCheck;
    if keydown     
      break;
    end
    
    disp(['frame: ' num2str(frameNumber) ' of ' num2str(length(frames))]);    
toc
end

% Shut down OpenGL rendering:
Screen('EndOpenGL', win);

%% finish 
% Close onscreen window and release all other ressources:
Screen('CloseAll');

% Reenable Synctests after this simple demo:
% Screen('Preference','SkipSyncTests',1);

% Well done!
end

