package com.cloudteam.cloudchat

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform