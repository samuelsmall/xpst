options
{
	tutorname="PDN";
}

sequence
{
	Check-Maintain-Aspect then (Set-Print-Height and Set-Print-Width and Set-Pixel-Width and Set-Pixel-Height);
}

mappings
{
	Resize.constrainCheckBox => Check-Maintain-Aspect;
	
	[focusedonly] Resize.printWidthUpDown => Set-Print-Width;
  [focusedonly] Resize.printHeightUpDown => Set-Print-Height;
	[focusedonly] Resize.pixelWidthUpDown => Set-Pixel-Width;
	[focusedonly] Resize.pixelHeightUpDown => Set-Pixel-Height;
}