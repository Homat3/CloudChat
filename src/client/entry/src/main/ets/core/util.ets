
export enum AVATAR {
  DEFAULT = "default.png",
  ZOMBATAR_1 = "avatar/Zombatar_1.jpg",
  ZOMBATAR_2 = "avatar/Zombatar_2.jpg",
  ZOMBATAR_3 = "avatar/Zombatar_3.jpg",
  ZOMBATAR_4 = "avatar/Zombatar_4.jpg",
  ZOMBATAR_5 = "avatar/Zombatar_5.jpg"
}

export function getAvatar(string: string | undefined | null): Resource {
  switch (string) {
    case AVATAR.DEFAULT:
      return $r("app.media.default");
    case AVATAR.ZOMBATAR_1:
      return $r("app.media.Zombatar_1");
    case AVATAR.ZOMBATAR_2:
      return $r("app.media.Zombatar_2");
    case AVATAR.ZOMBATAR_3:
      return $r("app.media.Zombatar_3");
    case AVATAR.ZOMBATAR_4:
      return $r("app.media.Zombatar_4");
    case AVATAR.ZOMBATAR_5:
      return $r("app.media.Zombatar_5");
    default:
      return $r("app.media.default");
  }
}
