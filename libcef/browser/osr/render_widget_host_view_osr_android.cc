// Copyright (c) 2014 The Chromium Embedded Framework Authors.
// Portions copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "libcef/browser/osr/render_widget_host_view_osr.h"
#include "libcef/browser/browser_host_impl.h"

// #include <X11/Xlib.h>
// #include <X11/cursorfont.h>
#undef Status  // Avoid conflicts with url_request_status.h

// #include "libcef/browser/native/window_x11.h"

#include "third_party/blink/public/platform/web_cursor_info.h"
#include "ui/base/x/x11_util.h"
#include "ui/gfx/x/x11_types.h"

void CefRenderWidgetHostViewOSR::PlatformCreateCompositorWidget(
    bool is_guest_view_hack) {
  /* // Create a hidden 1x1 window. It will delete itself on close.
  window_ = new CefWindowX11(NULL, None, gfx::Rect(0, 0, 1, 1));
  compositor_widget_ = window_->xwindow(); */
}

void CefRenderWidgetHostViewOSR::PlatformResizeCompositorWidget(
    const gfx::Size&) {}

void CefRenderWidgetHostViewOSR::PlatformDestroyCompositorWidget() {
  /* DCHECK(window_);
  window_->Close();
  compositor_widget_ = gfx::kNullAcceleratedWidget; */
}

/* ui::PlatformCursor CefRenderWidgetHostViewOSR::GetPlatformCursor(
    blink::WebCursorInfo::Type type) {
  if (type == WebCursorInfo::kTypeNone) {
    if (!invisible_cursor_) {
      invisible_cursor_.reset(new ui::XScopedCursor(ui::CreateInvisibleCursor(),
                                                    gfx::GetXDisplay()));
    }
    return invisible_cursor_->get();
  } else {
    return GetXCursor(ToCursorID(type));
  }
} */
