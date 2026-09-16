class_name CreatureData extends Resource
## How a creature can move
enum TargetMode { INPUT, FOLLOW, STAND }
## When a creature shoots
enum ShootMode { NEVER, ALWAYS, MOUSE }
## Where the creature moves
@export var movement = TargetMode.FOLLOW
## When the creature shoots
@export var shoot = ShootMode.NEVER
## How fast the creature moves, in u/s
@export var speed = 200
## How much health the creature can have at maximum
@export var maxhealth = 3.0
## The name of the creature's sprite in the tree
@export var spriteName = "Sprite"
## The name of the creature's gun in the tree
@export var gunName = "ParameterGun"
## What type of creature the creature is
@export var ownerMask : BulletData.OwnerClass = BulletData.OwnerClass.PLAYER
