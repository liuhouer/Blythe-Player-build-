procedure TMainPlay.btn1Click(Sender: TObject);
var nowindex:integer;
begin

if playlist.Lv1.ItemIndex <> -1 then //首先判断列表框中是否有内容
  begin
    mediaplayer1.FileName := playlist.Lv1.Selected.SubItems.Strings[0] + playlist.lv1.Selected.Caption; //
     ID3v1 := TID3v1.Create;
     id3v1.ReadFromFile(mediaplayer1.FileName);
     s2:=id3v1.Artist;
     s1:=id3v1.Title ;
     s3:=id3v1.Album;
    if MediaPlayer1.Mode in [mppaused] then
    begin
      MediaPlayer1.Resume;//恢复播放状态--记忆播放位置
      label1.Caption:='状态:播放 ';
      skyaudiometer1.Open;
      skyaudiometer1.Active:=true;
      vision.am2.Active:=true;


      btn1.Enabled := False;
      btn2.Enabled := True;
    end
    else
    begin
      try
        mediaplayer1.Open;
        mediaplayer1.Play; //播放列表框中选择的文件

        label1.Caption:='状态:播放 ';

        skyaudiometer1.active:=true;
        vision.am2.Active:=true;
        mediaplayer1.Notify := true;
        btn1.Enabled := false; //播放按钮变为不可用
        btn2.Enabled := true;
        btn3.Enabled := true; //暂停和停止按钮变为可用
        timer1.Enabled := true;
        timer2.Enabled := true;
        gd.Enabled:=true;
        listname.Caption:=extractfilename(MediaPlayer1.FileName);
        trackbar1.Enabled := true;
        stat1.Panels[0].Text := copy(extractfilename(MediaPlayer1.FileName),0,length(extractfilename(MediaPlayer1.FileName))-4);
        if ballhint1.Checked then
        begin
        rztray.ShowBalloonHint(copy(extractfilename(MediaPlayer1.FileName),0,length(extractfilename(MediaPlayer1.FileName))-4),'小步静听，静听精彩！',bhiinfo,10);
        end;
        if chk1.Checked=True then
        begin
        lrcshow.lst1.Clear;
        lrcshow.loadlrc(MediaPlayer1.FileName);
        end;
      except
           begin
             try
                nowindex := playlist.Lv1.ItemIndex;
                rztray.ShowBalloonHint('','not support,removing from playlist',bhiinfo,10);
                playlist.Lv1.DeleteSelected; //删除选中的列表项
                playlist.Lv1.ItemIndex:=nowindex;   //选中一项
                playlist.lv1DblClick(sender);
             except                            //保证不弹出捕获的异常代码
             end;

           end;
      end;


    end;
  end;

end;