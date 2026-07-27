Class {
	#name : 'OPBPMNEdgeModel',
	#superclass : 'OPDirectedAssociation',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'instance creation' }
OPBPMNEdgeModel class >> from: aSource to: aTarget [
	^ self new
		source: aSource;
		target: aTarget;
		yourself
]

{ #category : 'instance creation' }
OPBPMNEdgeModel class >> from: aSourceObject to: aTargetObject named: aString [
	^ self new
		from: aSourceObject to: aTargetObject;
		name: aString;
		yourself
]

{ #category : 'testing' }
OPBPMNEdgeModel >> isEdge [
	^ true
]

{ #category : 'testing' }
OPBPMNEdgeModel >> isNode [
	^ false
]

{ #category : 'accessing' }
OPBPMNEdgeModel >> printIdType [
	^ '_6-'
]

{ #category : 'printing' }
OPBPMNEdgeModel >> printType [
	^ self subclassResponsibility 
]
