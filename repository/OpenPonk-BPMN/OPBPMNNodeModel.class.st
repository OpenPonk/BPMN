Class {
	#name : 'OPBPMNNodeModel',
	#superclass : 'OPModelObject',
	#instVars : [
		'associations'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'adding' }
OPBPMNNodeModel >> addAssociation: anAssociation [
	(associations includes: anAssociation)
		ifTrue: [ ^ self ].
	associations add: anAssociation.
	anAssociation source = self
		ifTrue: [ 
			anAssociation addedTo: self.
			self announceAdded: anAssociation ]
		ifFalse: [ self changed ]
]

{ #category : 'accessing' }
OPBPMNNodeModel >> allElements [

	^ super allElements
	  , (self associations flatCollect: [ :each | each withAllElements ])
]

{ #category : 'accessing' }
OPBPMNNodeModel >> associations [

	^ associations
]

{ #category : 'accessing' }
OPBPMNNodeModel >> edges [

	^ associations
]

{ #category : 'hooks' }
OPBPMNNodeModel >> enclosingPool [

	^ self owner ifNotNil: [ self owner enclosingPool ]
]

{ #category : 'testing' }
OPBPMNNodeModel >> has: anElement [

	^ (super has: anElement) or: [ associations includes: anElement ]
]

{ #category : 'accessing' }
OPBPMNNodeModel >> incoming [

	^ associations select: [ :each | each target = self ]
]

{ #category : 'initialization' }
OPBPMNNodeModel >> initialize [

	super initialize.
	associations := OrderedCollection new
]

{ #category : 'testing' }
OPBPMNNodeModel >> isEdge [
	^ false
]

{ #category : 'testing' }
OPBPMNNodeModel >> isNode [
	^ true
]

{ #category : 'accessing' }
OPBPMNNodeModel >> nodes [
	^ elements 
]

{ #category : 'accessing' }
OPBPMNNodeModel >> outgoing [

	^ associations select: [ :each | each source = self ]
]

{ #category : 'removing' }
OPBPMNNodeModel >> removeAssociation: anAssociation [

	associations remove: anAssociation
]
