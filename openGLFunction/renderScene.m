
% sceneImage_rightLens = renderScene(...
% OBJfile_rightLens, meshColor_rightlens, ...
% renderImageSize(1), renderImageSize(2), cameraPosition_rightLens_32);

function sceneImage = renderScene(OBJfile, meshColor, ...
    screenWidth, screenHeight, ...
    cameraPosition_32)
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
win = Screen('OpenWindow', 0 ,[1 1 1], [0 0 screenWidth screenHeight]);

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
% glEnable(GL_LIGHT0);

% Enable two-sided lighting - Back sides of polygons are lit as well.
% glLightModelfv(GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);

% Define the cubes light reflection properties by setting up reflection
% coefficients for ambient, diffuse and specular reflection:
% glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT, [0.250000, 0.207250, 0.207250, 0.922000]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE, [1.000000, 0.829000, 0.829000, 0.922000]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR, [0.296648, 0.296648, 0.296648, 0.922000]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_SHININESS, 11.264000);

% color of Heiyaoshi
% glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT, [0.053750, 0.050000, 0.066250, 0.820000]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE, [0.182750, 0.170000, 0.225250, 0.820000]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR, [0.332741, 0.328634, 0.346435, 0.820000]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_SHININESS, 38.400002);

% color of ruby
% glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT, [0.174500, 0.011750, 0.011750, 0.550000]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE, [0.614240, 0.041360, 0.041360, 0.550000]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR, [0.727811, 0.626959, 0.626959, 0.550000]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_SHININESS, 76.800003);

% color of blue
% glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT, [0 0 1 1.0]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE, [0 0 1 1.0]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR, [0 0 1 1]);
% glMaterialfv(GL_FRONT_AND_BACK,GL_SHININESS, 128);

% Setup position and emission properties of the light source:
% glLightfv(GL_LIGHT0,GL_POSITION,[ -100 -500 0 1 ]);
% glLightfv(GL_LIGHT0,GL_DIFFUSE, [ 1 1 1 1 ]);
% glLightfv(GL_LIGHT0,GL_SPECULAR, [ 1 1 1 1 ]);
% glLightfv(GL_LIGHT0,GL_AMBIENT, [ 0 0 0 1 ]);
% glLightModelfv(GL_LIGHT_MODEL_AMBIENT, [0.2, 0.2, 0.2, 1.0]);

%% set up camera and projection matrix

% get projection and camera matrix (vector)
glMatrixMode(GL_PROJECTION);
glLoadIdentity;
glOrtho(-0.1,0.1,-0.1,0.1,0.001,1000);
% glLoadMatrixd(projectionMatrix);

glMatrixMode(GL_MODELVIEW);
glLoadIdentity;
gluLookAt(cameraPosition_32(1,1),cameraPosition_32(2,1),cameraPosition_32(3,1),...
    cameraPosition_32(1,2),cameraPosition_32(2,2),cameraPosition_32(3,2),...
    0,1,0);
% glLoadMatrixd(cameraMatrix);


% %% GLSL setup:
% glGetError;
% str = which('renderScene');
% 
% shaderpath = [str(1:end-length('renderScene.m')) 'Shader\'];
% glsl=LoadGLSLProgramFromFiles([shaderpath 'CameraPhongmethod_vertexarray'],1);
% gluErrorString
% 
% % Activate program:
% glUseProgram(glsl);
% gluErrorString
% 
% 
% 
% %% inital VAO
% 	vaoID = glGenVertexArrays(length(OBJfile));
%         vbo_positionID_all = glGenBuffers(length(OBJfile));
%         vbo_normalID_all = glGenBuffers(length(OBJfile));
%         
% for i = 1: length(OBJfile)
%     % face 
% 	glBindVertexArray(vaoID(i));    
%         vbo_positionID = vbo_positionID_all(i);
%         vbo_normalID = vbo_normalID_all(i);
%     glBindVertexArray(0);
%     
% %% rendering mesh
% %% load vertex data (position, normal, position2)
% %     
% % face    
%     OBJfile_this = OBJfile{i};
%     vertex_3V = [];
%     face_3F = [];
%     vertex_3V = OBJfile_this.vertex_3V;
%     face_3F = OBJfile_this.face_3F;
%     face_all_3FN{i} = face_3F;
%     
%     faceNormal_3F = getFaceNormal(vertex_3V,face_3F);
%     vertexNormal_3V = getVertexNormal(vertex_3V,face_3F,faceNormal_3F);  
%     
%     % vertexCoordinatesPerFace_33F contains the 3D coordinates (first dim)
% 	% of the three vertices (second dim) of the F faces (third dim)
%     vertexCoordinatesPerFace_33F = ...
%         reshape( vertex_3V( 1:3, face_3F(:) ), [3 3*size(face_3F,2)]);
% 
%     vertexNormalCoordinatesPerFace_33F = ...
%         reshape( vertexNormal_3V( 1:3, face_3F(:) ), [3 3*size(face_3F,2)]);
%         
% %% bind data to vertex array
% % face
%     glBindVertexArray(vaoID(i));   
% 
%         % bind vertex postion
%         glBindBuffer(GL_ARRAY_BUFFER, vbo_positionID); 	
%         glBufferData(GL_ARRAY_BUFFER, ...
%             size(vertexCoordinatesPerFace_33F,1)*...
%             size(vertexCoordinatesPerFace_33F,2)*8, ...
%             vertexCoordinatesPerFace_33F, GL_STATIC_DRAW); 
% 
%         glEnableVertexAttribArray(0);
%         glBindBuffer(GL_ARRAY_BUFFER, vbo_positionID);
%         glVertexAttribPointer(0, 3, GL_DOUBLE, GL_FALSE, 0, 0); 
% 
%         glBindBuffer(GL_ARRAY_BUFFER, 0);
%         
%         % bind vertex normal
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
%     
%     glBindVertexArray(0);  
%    
% end
%% Draw array
    glViewport(0, 0, screenWidth, screenHeight);
    glClearColor(1.0,1.0,1.0,1.0);
    glClearDepth(1.0);
    glClear;

%     glEnable(GL_CULL_FACE);
%     glScissor(500, 200, 800, 500);
%     glEnable(GL_SCISSOR_TEST);
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);    


% face    
for i = 1: length(OBJfile)
%     glBindVertexArray(vaoID(i));
% %         meshColor_this = meshColor{i};
% %         glColor3f(meshColor_this(1),meshColor_this(2),meshColor_this(3));
%         glDrawArrays(GL_TRIANGLES, 0, 3*size(face_all_3FN{i},2));  	
%     glBindVertexArray(0);
    OBJfile_this = OBJfile{i};
    vertex_3V = [];
    face_3F = [];
    vertex_3V = OBJfile_this.vertex_3V;
    face_3F = OBJfile_this.face_3F;
    
    glBegin(GL_TRIANGLES);
    meshColor_this = meshColor{i};
    glColor3f(meshColor_this(1),meshColor_this(2),meshColor_this(3));
    for j = 1: size(face_3F,2)
        glVertex3f(vertex_3V(1,face_3F(1,j)),vertex_3V(2,face_3F(1,j)),vertex_3V(3,face_3F(1,j)));
        glVertex3f(vertex_3V(1,face_3F(2,j)),vertex_3V(2,face_3F(2,j)),vertex_3V(3,face_3F(2,j)));
        glVertex3f(vertex_3V(1,face_3F(3,j)),vertex_3V(2,face_3F(3,j)),vertex_3V(3,face_3F(3,j)));
    end
    glEnd;
    


end    
%% read back the data
%     data = glReadPixels(500, 0, 1000, 1000, GL_RGB, GL_FLOAT);
    data = glReadPixels(0, 0, screenWidth, screenHeight, GL_RGB, GL_FLOAT);
    sceneImage = imrotate(double(data), 90);
%     imshow(sceneImage);

%%
% Finish OpenGL rendering into PTB window and check for OpenGL errors.
Screen('EndOpenGL', win);

%% finish 
% Close onscreen window and release all other ressources:
Screen('CloseAll');

% Reenable Synctests after this simple demo:
% Screen('Preference','SkipSyncTests',1);

% Well done!
end

