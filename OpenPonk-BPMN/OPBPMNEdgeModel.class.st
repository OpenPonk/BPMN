Class {
	#name : #OPBPMNEdgeModel,
	#superclass : #OPDirectedAssociation,
	#instVars : [
		'constraint'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #'instance creation' }
OPBPMNEdgeModel class >> from: aSource to: aTarget [
	^ self new
		source: aSource;
		target: aTarget;
		yourself
]

{ #category : #'instance creation' }
OPBPMNEdgeModel class >> from: aSourceObject to: aTargetObject named: aString [
	^ self new
		from: aSourceObject to: aTargetObject;
		name: aString;
		yourself
]

{ #category : #accessing }
OPBPMNEdgeModel >> constraint [
	^ constraint
]

{ #category : #accessing }
OPBPMNEdgeModel >> constraint: aConstraint [
	self hasConstraint
		ifTrue: [ ^ self ].
	constraint := aConstraint.
	aConstraint addedTo: self.
	self announceAdded: aConstraint
]

{ #category : #accessing }
OPBPMNEdgeModel >> constraints [
	^ constraint ifNil: [ #() ] ifNotNil: [ ^ {constraint} ]
]

{ #category : #'instance creation' }
OPBPMNEdgeModel >> from: aSource to: aTarget [
	self source: aSource.
	self target: aTarget
]

{ #category : #testing }
OPBPMNEdgeModel >> has: anEntity [
	^ constraint = anEntity
]

{ #category : #testing }
OPBPMNEdgeModel >> hasConstraint [
	^ constraint isNotNil
]

{ #category : #testing }
OPBPMNEdgeModel >> isEdge [
	^ true
]

{ #category : #testing }
OPBPMNEdgeModel >> isNode [
	^ false
]

{ #category : #testing }
OPBPMNEdgeModel >> removeConstraint [
	self hasConstraint
		ifFalse: [ ^ self ].
	constraint removedFrom: self.
	self announceRemoved: constraint.
	constraint := nil
]

{ #category : #accessing }
OPBPMNEdgeModel >> source [
	^ source
]

{ #category : #accessing }
OPBPMNEdgeModel >> source: aNode [
	source := aNode
]

{ #category : #accessing }
OPBPMNEdgeModel >> target [ 
	^ target
]

{ #category : #accessing }
OPBPMNEdgeModel >> target: aNode [
	target := aNode
]
