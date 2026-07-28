Class {
	#name : 'OPBPMNIcons',
	#superclass : 'OPIcons',
	#category : 'OpenPonk-BPMN-Icons',
	#package : 'OpenPonk-BPMN',
	#tag : 'Icons'
}

{ #category : 'accessing - icons' }
OPBPMNIcons class >> accessLink16Icon [

	^ Form fromBinaryStream:
		  self accessLink16IconContents base64Decoded asByteArray readStream
]

{ #category : 'private - contents' }
OPBPMNIcons class >> accessLink16IconContents [

	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAB7SURBVDhPxdM9DgFRGIXhh6AZ8ddhRGUZSrvQWI3CGiQqtqkZzak+o/A0k7ynmpt7+ZMdLhmrBrhinkPFNMM3WjwxzKFqj1nGii1OGasmuGOZQ8W4+46il6zx+OXAjlhlrNjgkLGqwQuLHCo+/9pEL2lx6+54L+e+DwPeI1MGW3diyysAAAAASUVORK5CYII='
]
