export function getAvatar(string: string | undefined | null): Resource {
  switch (string) {
    case "default.png":
      return $r("app.media.default");
    case "avatar/Zombatar_1.jpg":
      return $r("app.media.Zombatar_1");
    case "avatar/Zombatar_2.jpg":
      return $r("app.media.Zombatar_2");
    case "avatar/Zombatar_3.jpg":
      return $r("app.media.Zombatar_3");
    case "avatar/Zombatar_4.jpg":
      return $r("app.media.Zombatar_4");
    case "avatar/Zombatar_5.jpg":
      return $r("app.media.Zombatar_5");
    default:
      return $r("app.media.default");
  }
}