Class {
	#name : 'OPBPMNAbstractFlowModel',
	#superclass : 'OPBPMNEdgeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'instance creation' }
OPBPMNAbstractFlowModel class >> from: aSource to: aTarget [
	^ self new
		source: aSource;
		target: aTarget;
		yourself
]

{ #category : 'instance creation' }
OPBPMNAbstractFlowModel class >> from: aSourceObject to: aTargetObject named: aString [
	^ self new
		from: aSourceObject to: aTargetObject;
		name: aString;
		yourself
]

{ #category : 'accessing' }
OPBPMNAbstractFlowModel >> printIdType [
	^ '_6-'
]

{ #category : 'printing' }
OPBPMNAbstractFlowModel >> printType [
	^ self subclassResponsibility 
]
