# Automatization of Debian

Paso 1. Instalamos la herramienta oscdimg.exe
`https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install`

Paso 2. Montamos la imagen original en PowerShell

```bash
Mount-DiskImage -ImagePath "D:\iso\debian-13-amd64-netinst.iso"
```

> Revisamos en el explorador de archivos y veremos que letra le ha asigando, en el caso práctino nos muestra la letra F:

Copiamos el contenido:

```bash
xcopy F:\ D:\debian13-auto\build\ /E /H /K
```

Habilitamos los permisos de escritura:
chmod -R +w build/

Paso 3. Copiamos el archivo autoinstall.yaml dentro de D:\debian13-auto\build
Luego editamos el archivo boot\grub\grub.cfg y agrega el parámetro:

Debajo de D:\debian13-auto\build\boot\grub\grub.cfg

Buscar esto:

```bash
menuentry --hotkey=i 'Install' {
    set background_color=black
    linux    /install.amd/vmlinuz vga=788 --- quiet
    initrd   /install.amd/initrd.gz
}
```

Agregar debajo esto:

```bash
menuentry 'Automated Install (CD-ROM autoinstall.yaml)' {
    set background_color=black
    linux    /install.amd/vmlinuz auto=true priority=critical url=file:///cdrom/autoinstall.yaml vga=788 --- quiet
    initrd   /install.amd/initrd.gz
}
```

Paso 4. Agreagmos variable de entorno para que powershell detecte oscdimg

`C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg`

Paso 4. Generamos la nueva iso

```bash
oscdimg -m -o -u2 -udfver102 -bootdata:2#p0,e,bD:\debian13-auto\build\isolinux\isolinux.bin#pEF,e,bD:\debian13-auto\build\boot\grub\efi.img D:\debian13-auto\build D:\iso\debian13-auto-v2.iso
```
