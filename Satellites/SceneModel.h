//
//  SceneModel.h
//  
//

#import <GLKit/GLKit.h>
#import "SceneMesh.h"
#import "AGLKVertexAttribArrayBuffer.h"

@class AGLKVertexAttribArrayBuffer;
@class SceneMesh;


/////////////////////////////////////////////////////////////////
// Type that defines the bounding box for a model. No vertex
// position in the model has position.x less than min.x or 
// position.x greater than max.x. The same is true for Y and Z
// coordinates.
typedef struct
{
   GLKVector3 min;
   GLKVector3 max;
}
SceneAxisAllignedBoundingBox;


@interface SceneModel : NSObject

@property (copy, nonatomic, readwrite) NSString *name;
@property (assign, nonatomic, readwrite) SceneAxisAllignedBoundingBox axisAlignedBoundingBox;
@property (strong, nonatomic, readwrite) SceneMesh *mesh;
@property (nonatomic) GLsizei numberOfVertices;

- (id)initWithName:(NSString *)aName
   mesh:(SceneMesh *)aMesh
   numberOfVertices:(GLsizei)aCount;
   
- (void)draw;

- (void)updateAlignedBoundingBoxForVertices:(float *)verts
   count:(unsigned int)aCount;

@end
